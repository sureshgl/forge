package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dpi_task_protoContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dpi_task_protoContextExt extends AbstractBaseExt {

	public Dpi_task_protoContextExt(Dpi_task_protoContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dpi_task_protoContext getContext() {
		return (Dpi_task_protoContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dpi_task_proto());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dpi_task_protoContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Dpi_task_protoContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}