package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TablestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TablestrContextExt extends AbstractBaseExt {

	public TablestrContextExt(TablestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TablestrContext getContext() {
		return (TablestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).tablestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TablestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TablestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}