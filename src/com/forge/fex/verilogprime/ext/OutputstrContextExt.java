package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.OutputstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class OutputstrContextExt extends AbstractBaseExt {

	public OutputstrContextExt(OutputstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public OutputstrContext getContext() {
		return (OutputstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).outputstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof OutputstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + OutputstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected Boolean isOutput() {
		return true;
	}
}