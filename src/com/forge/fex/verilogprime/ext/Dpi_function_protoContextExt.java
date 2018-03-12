package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dpi_function_protoContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dpi_function_protoContextExt extends AbstractBaseExt {

	public Dpi_function_protoContextExt(Dpi_function_protoContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dpi_function_protoContext getContext() {
		return (Dpi_function_protoContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dpi_function_proto());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dpi_function_protoContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Dpi_function_protoContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}