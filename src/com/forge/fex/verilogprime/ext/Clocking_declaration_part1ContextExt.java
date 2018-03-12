package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Clocking_declaration_part1Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Clocking_declaration_part1ContextExt extends AbstractBaseExt {

	public Clocking_declaration_part1ContextExt(Clocking_declaration_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Clocking_declaration_part1Context getContext() {
		return (Clocking_declaration_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).clocking_declaration_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Clocking_declaration_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Clocking_declaration_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}