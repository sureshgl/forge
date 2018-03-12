package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Elaboration_system_taskContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Elaboration_system_taskContextExt extends AbstractBaseExt {

	public Elaboration_system_taskContextExt(Elaboration_system_taskContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Elaboration_system_taskContext getContext() {
		return (Elaboration_system_taskContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).elaboration_system_task());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Elaboration_system_taskContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Elaboration_system_taskContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}